using System.Collections.Generic;
using UnityEngine;

public class CubeWaveManager : MonoBehaviour {

    public static CubeWaveManager Instance;

    [Header("Requires reset")]
    [SerializeField] private int _width = 40;
    [SerializeField] private int _depth = 40;
    [SerializeField] private float _distanceMultiplier = 1;
    [SerializeField] private float _waveSmoothing = 0.8f;
    [SerializeField] private Vector3Int _orangeCube;

    [Header("Runtime adjustable")]
    [Range(0.05f,3)]public float WaveMagnitude = 0.1f;

    [Header("Misc")]
    [SerializeField] private WaveCube _waveCubePrefab;

    private readonly List<WaveCube> _spawnedCubes = new List<WaveCube>();

    void Awake() {
        Instance = this;
    }

    void Start()
    {
        for (int x = 0; x < _width; x++) {
            for (int z = 0; z < _depth; z++) {
                var grisPos = new Vector3Int(x, 0, z);
                var spawnedCube = Instantiate(_waveCubePrefab, new Vector3(x, 0, z) * _distanceMultiplier, Quaternion.identity,transform);
                spawnedCube.Init(grisPos, ((x + z) * _waveSmoothing) * 0.5f, grisPos == _orangeCube);
                _spawnedCubes.Add(spawnedCube);
            }
        }
    }
}