package org.andresoviedo.android_3d_model_engine.services.collada.entities;

import java.util.ArrayList;
import java.util.List;

public final class VertexSkinData {
	
	public final List<Integer> jointIds = new ArrayList<>(3);
	public final List<Float> weights = new ArrayList<>(3);
	
	public void addJointEffect(int jointId, float weight){
		for(int i=0;i<weights.size();i++){
			if(weight > weights.get(i)){
				jointIds.add(i, jointId);
				weights.add(i, weight);
				return;
			}
		}
		jointIds.add(jointId);
		weights.add(weight);
	}
	
	public void limitJointNumber(int max){
		if(jointIds.size() > max){
			float[] topWeights = new float[max];
			float total = saveTopWeights(topWeights);
			refillWeightList(topWeights, total);
			removeExcessJointIds(max);
		}else if(jointIds.size() < max){
			fillEmptyWeights(max);
		}
	}

	private void fillEmptyWeights(int max){
		while(jointIds.size() < max){
			jointIds.add(0);
			weights.add(0f);
		}
	}
	
	private float saveTopWeights(float[] topWeightsArray){
		float total = 0;
		for(int i=0;i<topWeightsArray.length;i++){
			topWeightsArray[i] = weights.get(i);
			total += topWeightsArray[i];
		}
		return total;
	}
	
	private void refillWeightList(float[] topWeights, float total){
		weights.clear();
		for(int i=0;i<topWeights.length;i++){
			weights.add(Math.min(topWeights[i]/total, 1));
		}
	}
	
	private void removeExcessJointIds(int max){
		while(jointIds.size() > max){
			jointIds.remove(jointIds.size()-1);
		}
	}

	@Override
	public String toString() {
		return "VertexSkinData{" +
				"jointIds=" + jointIds +
				", weights=" + weights +
				'}';
	}
}
