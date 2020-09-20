package org.andresoviedo.android_3d_model_engine.services.collada.loader;

import android.opengl.Matrix;
import android.util.Log;

import org.andresoviedo.android_3d_model_engine.services.collada.entities.JointData;
import org.andresoviedo.android_3d_model_engine.services.collada.entities.MeshData;
import org.andresoviedo.android_3d_model_engine.services.collada.entities.SkeletonData;
import org.andresoviedo.android_3d_model_engine.services.collada.entities.SkinningData;
import org.andresoviedo.android_3d_model_engine.services.collada.entities.Vertex;
import org.andresoviedo.android_3d_model_engine.services.collada.entities.VertexSkinData;
import org.andresoviedo.util.math.Math3DUtils;
import org.andresoviedo.util.xml.XmlNode;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class SkinLoader {

	private final XmlNode controllersNode;
	private XmlNode skinningData;
	private final int maxWeights;

	public SkinLoader(XmlNode controllersNode, int maxWeights) {
		this.maxWeights = maxWeights;
		this.controllersNode = controllersNode;
	}

	public Map<String, SkinningData> loadSkinData() {
		Map<String, SkinningData> ret = new HashMap<>();
		for (XmlNode controller : controllersNode.getChildren("controller")) {
			this.skinningData = controller.getChild("skin");
			String source = skinningData.getAttribute("source").substring(1);
			Log.i("SkinLoader", "Loading skin... " + source);

			// bind shape matrix
			float[] bindShapeMatrix = null;
			XmlNode bindShapeMatrixNode = skinningData.getChild("bind_shape_matrix");
			if (bindShapeMatrixNode != null) {
				float[] bind_shape_matrix_data = Math3DUtils.parseFloat(bindShapeMatrixNode.getData().trim().split("\\s+"));
				bindShapeMatrix = new float[16];
				Matrix.transposeM(bindShapeMatrix, 0, bind_shape_matrix_data, 0);
				Log.i("SkinLoader", "Bind shape matrix: " + Math3DUtils.toString(bindShapeMatrix, 0));
			}

			// Ordered joint list
			List<String> jointNames = loadJointNames();
			Log.i("SkinLoader", "Joints found: " + jointNames.size() + ", names: " + jointNames);

			// Vertex weights
			float[] weights = loadWeights();

			// every vertex has 1 or more joints/weights associated
			XmlNode weightsDataNode = skinningData.getChild("vertex_weights");
			int[] effectorJointCounts = getEffectiveJointsCounts(weightsDataNode);

			// load skin data for every vertex
			List<VertexSkinData> vertexWeights = loadSkinData(weightsDataNode, effectorJointCounts, weights);

			// inverse bind matrix
			float[] inverseBindMatrix = null;
			try {
				XmlNode joints = skinningData.getChild("joints");
				XmlNode inverseBindMatrixNode = joints.getChildWithAttribute("input", "semantic", "INV_BIND_MATRIX");
				String invMatrixString = skinningData.getChildWithAttribute("source",
						"id", inverseBindMatrixNode.getAttribute("source").substring(1))
						.getChild("float_array").getData();
				Log.d("SkinLoader", "invMatrix: " + invMatrixString.trim());
				inverseBindMatrix = Math3DUtils.parseFloat(invMatrixString.trim().split("\\s+"));
				Log.d("SkinLoader", "Inverse bind matrix: " + Math3DUtils.toString(inverseBindMatrix, 0));
			} catch (Exception e) {
				Log.i("SkinLoader", "No inverse bind matrix available");
			}
			ret.put(source, new SkinningData(bindShapeMatrix, jointNames, vertexWeights, inverseBindMatrix));
		}
		Log.i("SkinLoader", "Skinning data list loaded: " + ret.keySet());
		return ret;
	}

	private List<String> loadJointNames() {
		XmlNode inputNode = skinningData.getChild("vertex_weights");
		String jointDataId = inputNode.getChildWithAttribute("input", "semantic", "JOINT").getAttribute("source")
				.substring(1);
		XmlNode jointsNode = skinningData.getChildWithAttribute("source", "id", jointDataId).getChild("Name_array");
		String[] names = jointsNode.getData().trim().split("\\s+");
		List<String> jointsList = new ArrayList<>();
		Collections.addAll(jointsList, names);
		return jointsList;
	}

	private float[] loadWeights() {
		XmlNode inputNode = skinningData.getChild("vertex_weights");
		String weightsDataId = inputNode.getChildWithAttribute("input", "semantic", "WEIGHT").getAttribute("source")
				.substring(1);
		XmlNode weightsNode = skinningData.getChildWithAttribute("source", "id", weightsDataId).getChild("float_array");
		String[] rawData = weightsNode.getData().trim().split("\\s+");
		float[] weights = new float[rawData.length];
		for (int i = 0; i < weights.length; i++) {
			weights[i] = Float.parseFloat(rawData[i]);
		}
		return weights;
	}

	private int[] getEffectiveJointsCounts(XmlNode weightsDataNode) {
		String[] rawData = weightsDataNode.getChild("vcount").getData().trim().split("\\s+");
		int[] counts = new int[rawData.length];
		for (int i = 0; i < rawData.length; i++) {
			counts[i] = Integer.parseInt(rawData[i]);
		}
		return counts;
	}

	private List<VertexSkinData> loadSkinData(XmlNode weightsDataNode, int[] counts, float[] weights) {
		String[] rawData = weightsDataNode.getChild("v").getData().trim().split("\\s+");
		List<VertexSkinData> skinningData = new ArrayList<VertexSkinData>();
		int pointer = 0;
		for (int count : counts) {
			VertexSkinData skinData = new VertexSkinData();
			for (int i = 0; i < count; i++) {
				int jointId = Integer.parseInt(rawData[pointer++]);
				int weightId = Integer.parseInt(rawData[pointer++]);
				skinData.addJointEffect(jointId, weights[weightId]);
			}
			skinData.limitJointNumber(maxWeights);
			skinningData.add(skinData);
		}
		return skinningData;
	}

	public static void loadSkin(MeshData meshData, Map<String, SkinningData> skinningDataMap, SkeletonData skeletonData){

		loadSkinningData(meshData, skinningDataMap, skeletonData);
		loadSkinningArrays(meshData, skinningDataMap);

		Log.d("SkinLoader", "Loaded skinning data: "
				+ "jointIds: " + (meshData.getJointsArray() != null ? meshData.getJointsArray().length : 0)
				+ ", weights: " + (meshData.getWeightsArray() != null ? meshData.getWeightsArray().length : 0));
	}

	private static void loadSkinningData(MeshData meshData, Map<String, SkinningData> skinningDataMap, SkeletonData skeletonData) {

		Log.d("SkinLoader", "Loading skinning data...");
		final String geometryId = meshData.getId();

		// load bind_shape_matrix
		if (skinningDataMap != null && skinningDataMap.containsKey(geometryId)) {
			float[] bindShapeMatrix = skinningDataMap.get(geometryId).getBindShapeMatrix();
			if (bindShapeMatrix != null) {
				Log.d("SkinLoader", "Found bind_shape_matrix");
				meshData.setBindShapeMatrix(bindShapeMatrix);
			}
		}

		List<VertexSkinData> verticesSkinData = null;
		if (skinningDataMap == null || !skinningDataMap.containsKey(geometryId)) {
			Log.d("SkinLoader", "No skinning data available");
		} else {
			verticesSkinData = skinningDataMap.get(geometryId).verticesSkinData;
		}

		// link vertex to weight data
		for (int i = 0; i < meshData.getVerticesAttributes().size(); i++) {

			Vertex vertex = meshData.getVerticesAttributes().get(i);

			// skinning data
			VertexSkinData weightsData = null;
			if (verticesSkinData != null) {
				weightsData = verticesSkinData.get(vertex.getVertexIndex());
			}

			// failover to skeleton if no skinning data is available
			if (weightsData == null & skeletonData != null) {
				// FIXME: process all joints?
				JointData jointData = skeletonData.getHeadJoint().find(geometryId);
				if (jointData == null) {
					Log.v("SkinLoader", "Joint not found for " + geometryId + ". Using root joint");
					jointData = skeletonData.getHeadJoint();
				} else {
					Log.v("SkinLoader", "Joint found for " + geometryId + ". Bone " + jointData.getName());
				}
				if (jointData != null) {
					Log.v("SkinLoader", "vertex_weights not found. Using root joint effect");
					weightsData = new VertexSkinData();
					weightsData.addJointEffect(jointData.getIndex(), 1);
					weightsData.limitJointNumber(3);
				}
			}

			vertex.setWeightsData(weightsData);
		}
	}

	private static void loadSkinningArrays(MeshData meshData, Map<String, SkinningData> skinningDataMap) {

		Log.d("SkinLoader", "Loading skinning arrays...");
		final String geometryId = meshData.getId();
		final List<Vertex> vertexList = meshData.getVerticesAttributes();

		if (skinningDataMap != null && skinningDataMap.containsKey(geometryId) ||
				vertexList.size() > 0 && vertexList.get(0).getWeightsData() != null) {
			int[] jointsArray = new int[vertexList.size() * vertexList.get(0).getWeightsData().jointIds.size()];
			float[] weightsArray = new float[vertexList.size() * vertexList.get(0).getWeightsData().weights.size()];

			int gw = 0, gj = 0; // global weights, global joints
			for (int i = 0; i < vertexList.size(); i++) {
				Vertex currentVertex = vertexList.get(i);
				VertexSkinData weights = currentVertex.getWeightsData();
				if (weights != null) {
					for (int j = 0; j < weights.jointIds.size(); j++) {
						jointsArray[gj++] = weights.jointIds.get(j);
					}
					for (int w = 0; w < weights.weights.size(); w++) {
						weightsArray[gw++] = weights.weights.get(w);
					}
				}
			}

			meshData.setJointsArray(jointsArray);
			meshData.setWeightsArray(weightsArray);
		}
	}
}
