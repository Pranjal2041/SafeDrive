enum CarParts2{
  WindShield,

}

class CarPartsClass2 {

  static getStringFromCarParts(CarParts2 a){
    return a.toString().substring("CarParts2".length+1);
  }

  static convertPartsMapToStringMap(Map data){
    Map res = new Map();
    data.forEach((key, value) {
      res[getStringFromCarParts(key)] = value;
    });
    return res;
  }

}