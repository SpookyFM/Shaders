using UnityEngine;
using System.Collections;


/// <summary>
/// Animates the "Cull" value
/// </summary>
public class ClipAnimator : MonoBehaviour {

    /// <summary>
    /// The range in which the value is animated.
    /// </summary>
    public float animDistance;

    /// <summary>
    /// The distance at which the effect should start/stop.
    /// </summary>
    public float farDistance;

	// Use this for initialization
	void Start () {
	
	}

	// Update is called once per frame
	void Update () {

        // Check for all objects in the scene whether they are about to be "culled"
        foreach(GameObject gameObj in GameObject.FindObjectsOfType<GameObject>())
        {
            float distance = farDistance - Vector3.Distance(Camera.main.transform.position, gameObj.transform.position); // farPlane.GetDistanceToPoint(gameObj.transform.position);
            float anim = distance / animDistance;
            anim = Mathf.Clamp01(anim);

            // Debug.Log(anim);
            
            MeshRenderer mr = gameObj.GetComponent<MeshRenderer>();
            if (mr != null)
            {
                mr.material.SetFloat("_Cull", anim);
            }
        }
	}
}
