package com.pranjal.model_renderer;

public class RenderingColorClass {

    private float[] ambientColor;
    private float[] diffuseColor;

    RenderingColorClass(float[] ambientColor,float[] diffuseColor){
        this.ambientColor = ambientColor;
        this.diffuseColor = diffuseColor;
    }

    public float[] getAmbientColor() {
        return ambientColor;
    }

    public void setAmbientColor(float[] ambientColor) {
        this.ambientColor = ambientColor;
    }

    public float[] getDiffuseColor() {
        return diffuseColor;
    }

    public void setDiffuseColor(float[] diffuseColor) {
        this.diffuseColor = diffuseColor;
    }
}
