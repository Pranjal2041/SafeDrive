enum CarParts{
  Left_View_Mirror,
  Right_View_Mirror,
  Front,
  Back
}

class CarPartsClass {

  static getStringFromCarParts(CarParts a){
    return a.toString().substring("CarParts".length+1);
  }

  static convertPartsMapToStringMap(Map data){
    Map res = new Map();
    data.forEach((key, value) {
      res[getStringFromCarParts(key)] = value;
    });
    return res;
  }

}