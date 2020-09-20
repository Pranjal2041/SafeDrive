package com.pranjal.model_renderer;

enum ModelViewType{
    Normal,
    Points,
    Mesh,
    X_RAY
}


class ModelViewTypeClass{
    public static ModelViewType getViewTypeFromString(String a){
        switch (a){
            case "Normal":
                return ModelViewType.Normal;
            case "Points":
                return ModelViewType.Points;
            case "Mesh":
                return ModelViewType.Mesh;
            case "X_RAY":
                return ModelViewType.X_RAY;
        }
        return null;
    }
}
