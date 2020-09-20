package com.pranjal.model_renderer.data;


import java.util.Hashtable;

public class CodeMappings {

    public static Hashtable<String, Integer> codeMapping = new Hashtable<String, Integer>(){{
        put("Left_View_Mirror",1);
        put("Right_View_Mirror",2);
        put("Back",0);
        put("Front",3);
    }};


}
