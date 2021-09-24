using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Mover : MonoBehaviour {
    [SerializeField] private Vector3 _dir;
    void Update()
    {
        transform.Translate(_dir * Time.deltaTime);
    }
}
