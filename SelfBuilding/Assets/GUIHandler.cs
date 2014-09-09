using UnityEngine;
using System.Collections;

public class GUIHandler : MonoBehaviour {


    float hSliderValue;

    public GameObject Target;

    public Shader FullShader;

    public Shader RotationShader;

    public Shader DownwardShader;

    public Shader OutwardShader;


	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

    private void SwitchShader(Shader shader)
    {
        Target.GetComponent<MeshRenderer>().material.shader = shader;
    }

    private void UpdateShaderValue(float anim)
    {
        MeshRenderer mr = Target.GetComponent<MeshRenderer>();
        if (mr != null)
        {
            mr.material.SetFloat("_Animation", anim);
        }
    }

    void OnGUI()
    {
        // TODO: Layout nicely
        // TODO: Actually set values
        // TODO: Make different versions of the shader


        GUILayout.BeginArea(new Rect(Screen.width - 280, 50, 260, 300));
        
        GUILayout.BeginVertical("box");
        GUILayout.Label("Choose a shader:");
        if (GUILayout.Button("Full Shader"))
            SwitchShader(FullShader);
        if (GUILayout.Button("Rotations"))
            SwitchShader(RotationShader);
        if (GUILayout.Button("Downward movement"))
            SwitchShader(DownwardShader);
        if (GUILayout.Button("Outward movement"))
            SwitchShader(OutwardShader);

        GUILayout.Label("Animation Value:");
        GUILayout.BeginHorizontal();
        hSliderValue = GUILayout.HorizontalSlider(hSliderValue, 0.0F, 5.0F, GUILayout.ExpandWidth(true));
        GUILayout.Label(new GUIContent(hSliderValue.ToString("0.00")), GUILayout.ExpandWidth(false));
        UpdateShaderValue(hSliderValue);
        

        GUILayout.EndHorizontal();

        GUILayout.EndVertical();
        GUILayout.EndArea();

    }
}
