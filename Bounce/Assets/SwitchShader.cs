using UnityEngine;
using System.Collections;

/// <summary>
/// Switches between two versions of a shader on the tagged objects.
/// </summary>
public class SwitchShader : MonoBehaviour {

    public Shader shader;

    public Shader valuesShader;

    private bool isSwitched;

    public string tag;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Shader shaderToApply;
            if (isSwitched)
            {
                shaderToApply = shader;
            }
            else
            {
                shaderToApply = valuesShader;
            }
            isSwitched = !isSwitched;

            foreach (GameObject obj in GameObject.FindGameObjectsWithTag(tag))
            {
                obj.GetComponent<MeshRenderer>().material.shader = shaderToApply;
            }

        }
	}
}
