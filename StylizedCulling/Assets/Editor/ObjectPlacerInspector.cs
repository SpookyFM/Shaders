using System;
using System.Collections.Generic;
using UnityEngine;
using System.Collections;
using UnityEditor;

[CustomEditor(typeof(ObjectPlacer))]
public class ObjectPlacerInspector: Editor
{
    private void PlaceObjects()
    {
        // Clear the existing objects
        ObjectPlacer placer = target as ObjectPlacer;

       DeleteAllChildren(placer.transform);

        // Fill with new objects

        float x = -placer.Width/2.0f;
        float y = -placer.Height/2.0f;

        while (x < placer.Width * 0.5f)
        {
            y = -placer.Height / 2.0f;
            while (y < placer.Height * 0.5f)
            {
                int objNumber = UnityEngine.Random.Range(0, placer.Objects.Count);
                
                GameObject obj = (GameObject)GameObject.Instantiate(placer.Objects[objNumber]);

                int matNumber = UnityEngine.Random.Range(0, placer.Materials.Count);
                
                Material material = placer.Materials[matNumber];

                obj.renderer.material = material;

                obj.transform.parent = placer.transform;

                // Add a random offset
                float randX = UnityEngine.Random.Range(0.0f, placer.GridSize) - placer.GridSize;
                float randY = UnityEngine.Random.Range(0.0f, placer.GridSize) - placer.GridSize;

                obj.transform.localPosition = new Vector3(x + randX, obj.transform.localPosition.z, y + randY);
                
                // Scale the object
                float scale = UnityEngine.Random.RandomRange(placer.MinScaleY, placer.MaxScaleY);
                obj.transform.localScale = new Vector3(obj.transform.localScale.x, scale, obj.transform.localScale.z);


                y += placer.GridSize;
            }

            x += placer.GridSize;
        }


        
    }

    private void DeleteAllChildren(Transform transform)
    {
        int childCount = transform.childCount;
        for (int i = 0; i < childCount; i++)
        {
            DestroyImmediate(transform.GetChild(0).gameObject);
        }
    }


    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();


    
        if (GUILayout.Button("Generate"))
        {
            PlaceObjects();
        }
    }
}