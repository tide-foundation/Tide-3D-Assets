using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FaceCubeManager : MonoBehaviour {
    [SerializeField] private GameObject _prefab;

    [SerializeField] private int _count = 2000;

    [SerializeField] private float _radius = 30;


    void Start()
    {
        for (int i = 0; i < _count; i++) {
            var cube = Instantiate(_prefab, transform.position + Random.insideUnitSphere * _radius, Quaternion.identity,transform);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void OnDrawGizmos() {
        Gizmos.color = Color.red;

        Gizmos.DrawWireSphere(transform.position, _radius);
    }
}
