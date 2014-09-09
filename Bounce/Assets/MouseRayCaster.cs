using UnityEngine;
using System.Collections;

/// <summary>
/// Play the bounce effect at the position where the user clicked.
/// </summary>
public class MouseRayCaster : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	void OnMouseDown() {
		// Find the position where the user clicked
		Camera camera = Camera.main;
		Ray ray = camera.ScreenPointToRay(Input.mousePosition);
		RaycastHit hit;
		if (Physics.Raycast(ray, out hit, 100)) {
			Debug.DrawLine(ray.origin, hit.point);
			HandleHit(hit);
		}
	}

	private void HandleHit(RaycastHit hit)
	{
		// Feed the information to the shader
		// Where was the hit?
		gameObject.GetComponent<MeshRenderer>().material.SetVector("_HitLocation", new Vector4(hit.point.x, hit.point.y, hit.point.z, 1.0f));

        Vector3 normal = hit.normal;

        normal = gameObject.transform.rotation * normal;

		// What is the hit normal?
		gameObject.GetComponent<MeshRenderer>().material.SetVector("_Impact", new Vector4(normal.x, normal.y, normal.z, 0.0f));
		
		
		// Start the animation
		GetComponent<Animator>().SetTrigger("Bounce");
	}
}
