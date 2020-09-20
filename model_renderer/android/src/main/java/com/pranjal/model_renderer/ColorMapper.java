package com.pranjal.model_renderer;


import android.graphics.Color;

import com.pranjal.model_renderer.data.CodeMappings;

import java.util.HashMap;
import java.util.Map;

public class ColorMapper {

    public static Map<Integer, RenderingColorClass> mapFromRawData(Map<String,Integer> raw){
        Map<Integer,RenderingColorClass> res = new HashMap<>();
        int sum = 0;
        for (Map.Entry<String, Integer> me : raw.entrySet()) {
                sum += me.getValue();
        }
        for (Map.Entry<String, Integer> me : raw.entrySet()) {
            Integer col = CodeMappings.codeMapping.get(me.getKey());
            if(col!=null)
                res.put(col,calculateColor(me.getValue()/(sum+0.0)));
        }
        return res;
    }

    static RenderingColorClass calculateColor(double percentage){
//        float hue = (float) (120-120*percentage);
//        float sat = 1f;
//        float val = 1f;
//        int a = Color.HSVToColor(new float[]{hue,sat,val});
//        int red = Color.red(a);
//        int green = Color.green(a);
//        int blue = Color.blue(a);
//        return new RenderingColorClass(new float[]{(float)( percentage*0.5)+0.4f, 0,0,0.95f},
//                new float[]{(float) (percentage*0.5)+0.4f, 0, 0,0.95f});

        float start[] = new float[]{0.454f,0.081f,0.081f};
        float end[] = new float[]{0.901f,0.427f,0.427f};
        float r = (float) (start[0]+percentage*(end[0]-start[0]));
        float g = (float) (start[1]+percentage*(end[1]-start[1]));
        float b = (float) (start[2]+percentage*(end[2]-start[2]));

        if(percentage<0.1){
            return new RenderingColorClass(new float[]{0.86f,0.86f,0.86f,0.94f},new float[]{0.86f,0.86f,0.86f,0.94f});
        }

        return new RenderingColorClass(new float[]{r,g,b,0.94f},new float[]{r,g,b,0.94f});
    }


}
