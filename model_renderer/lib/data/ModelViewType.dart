enum ModelViewType{
  Normal,
  Points,
  Mesh,
  X_RAY
}


class ModelViewTypeClass {
 static getStringFromViewType(ModelViewType type){
   switch(type) {
     case ModelViewType.Normal:
       return "Normal";
     case ModelViewType.Points:
       return "Points";
     case ModelViewType.Mesh:
       return "Mesh";
     case ModelViewType.X_RAY:
       return "X_RAY";
   }
 }
}