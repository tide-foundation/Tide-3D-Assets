using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NewMover : MonoBehaviour {
    private Vector3 _startPos;
    [SerializeField] private Vector3 _end;
    [SerializeField] private Transform _target;
    [SerializeField] private float _smoothTime = 0.01f;
    [SerializeField] private float _speed = 0.25f;


    private Vector3 _vel;
    void Update() {
        transform.position = Vector3.MoveTowards(transform.position, _target.position, _speed * Time.deltaTime);
    }
}
