using UnityEngine;
using System.Collections;

/// <summary>
/// Detect collisions with the weapon of the character and play the bounce effect by starting the animation.
/// </summary>
public class MeleeCollision : MonoBehaviour {


    private float lastCollision = -10.0f;

    /// <summary>
    /// The time duration before a new collision may start in seconds
    /// </summary>
    public float collisionTimer = 1.0f;

    public GameObject player;

	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
	
	}

    

    void OnCollisionEnter(Collision col)
    {
        // Don't place a new collision if the attack animation is still playing
        if (!player.animation.IsPlaying("attack"))
            return;
       
        
        if (col.gameObject.tag == "Hittable")
        {
            // Wait until collisionTimer has elapsed before placing a new collision
            if (Time.time > lastCollision + collisionTimer)
            {
                HandleHit(col);
                lastCollision = Time.time;
            }
        } 
    }

    private void HandleHit(Collision col)
    {
        // Feed the information to the shader
        // Where was the hit?
        gameObject.GetComponent<MeshRenderer>().material.SetVector("_HitLocation", new Vector4(col.contacts[0].point.x, col.contacts[0].point.y, col.contacts[0].point.z, 1.0f));

        // What is the hit normal?
        gameObject.GetComponent<MeshRenderer>().material.SetVector("_Impact", new Vector4(col.contacts[0].normal.x, col.contacts[0].normal.y, col.contacts[0].normal.z, 0.0f));


        // Start the animation
        GetComponent<Animator>().SetTrigger("Bounce");
    }

    

   

}
