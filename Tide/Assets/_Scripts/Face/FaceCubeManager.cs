using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class FaceCubeManager : MonoBehaviour {
    [SerializeField] private GameObject _prefab;

    [SerializeField] private int _count = 2000;

    [SerializeField] private float _radius = 30;
    
    [SerializeField] private float _scatterAmount = 1;
    [SerializeField] private Transform _faceParent;

    [SerializeField] private float _minSpeed = 2, _maxSpeed = 4;

    [SerializeField] private Transform _camTransform;
    [SerializeField] private Vector3 _startRot = new Vector3(0,-30,0), _endRot = new Vector3(0,-180,0);
    [SerializeField] private Ease _cubeEase;
    void Start()
    {
        //for (int i = 0; i < _count; i++) {
        //    var cube = Instantiate(_prefab, transform.position + Random.insideUnitSphere * _radius, Quaternion.identity,transform);
        //    var scale = Random.Range(-_scaleModifier, _scaleModifier) + cube.transform.localScale.x;
        //    _cubes.Add(cube.transform);
        //   // cube.transform.localScale = new Vector3(scale, scale, scale);
        //}
     
        foreach (Transform cube in _faceParent) {
            var startPos = cube.position;
            cube.position = cube.position + Random.insideUnitSphere * _scatterAmount;

            cube.DOMove(startPos, Random.Range(_minSpeed, _maxSpeed)).SetEase(_cubeEase);
        }

        _camTransform.rotation = Quaternion.Euler(_startRot);
        _camTransform.DORotate(_endRot, _maxSpeed);
    }

    //private float _vel;
 
    //void Update() {
    //    _camTransform.rotation = Quaternion.RotateTowards(_camTransform.rotation,Quaternion.Euler(_endRot), )
    //_scatterAmount = Mathf.SmoothDamp(_scatterAmount, 1,ref _vel, _smooth, _speed * Time.deltaTime);

    //    for (int i = 0; i < _cubes.Count; i++) {
    //        _cubes[i].position = Vector3.MoveTowards(_cubes[i].position, _startPositions[i], _cubeSpeeds[i] * Time.deltaTime); // (_startPositions[i] * _scatterAmount); //(_startPositions[i] + (Random.insideUnitSphere * _scatterAmount));
    //    }

    //}

    void OnDrawGizmos() {
        Gizmos.color = Color.red;

        Gizmos.DrawWireSphere(transform.position, _radius);
    }
}


