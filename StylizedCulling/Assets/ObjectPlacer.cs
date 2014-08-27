using UnityEngine;
using System.Collections.Generic;


/// <summary>
/// Places a set of objects with randomized materials and heights on a regular grid, offsetting the position randomly.
/// </summary>
public class ObjectPlacer : MonoBehaviour {

    /// <summary>
    /// The objects to place
    /// </summary>
    public List<GameObject> Objects;

    /// <summary>
    /// The materials to apply
    /// </summary>
    public List<Material> Materials;

    /// <summary>
    /// The width of the area to cover
    /// </summary>
    public float Width;

    /// <summary>
    /// The height of the area to cover
    /// </summary>
    public float Height;

    /// <summary>
    /// The size of one rectangle of the grid
    /// </summary>
    public float GridSize;

    /// <summary>
    /// The minimal Y-scale to apply
    /// </summary>
    public float MinScaleY;

    /// <summary>
    /// The maximum Y-scale to apply
    /// </summary>
    public float MaxScaleY;
}
