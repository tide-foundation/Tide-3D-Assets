using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BreachCubeManager : MonoBehaviour
{
    [SerializeField] private BreachCube _cubePrefab;
    [SerializeField] private int _width = 40;
    [SerializeField] private int _height = 40;
    [SerializeField] private float _distanceMultiplier = 1;
    [SerializeField] private Vector3 _orangeCube;
    [SerializeField] private Material _orangeMaterial;
    void Start()
    {
        for (int x = 0; x < _width; x++)
        {
            for (int y = 0; y < _height; y++) {
                var pos = new Vector3(x, y, 0);
                var spawnedCube = Instantiate(_cubePrefab, new Vector3(x, y,0) * _distanceMultiplier, Quaternion.identity, transform);
                if (_orangeCube == pos) spawnedCube.GetComponent<MeshRenderer>().material = _orangeMaterial;
            }
        }
    }
}
