using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;
using UnityEngine.Experimental.GlobalIllumination;
using UnityEngine.Rendering.PostProcessing;

public class FaceCubeManager : MonoBehaviour {

    [SerializeField] private float _scatterAmount = 1;
    [SerializeField] private Transform _faceParent;
    [SerializeField] private GameObject _particles;
    [SerializeField] private float _minSpeed = 2, _maxSpeed = 4;

    [SerializeField] private Transform _camTransform;
    [SerializeField] private Vector3 _startRot = new Vector3(0,-30,0), _endRot = new Vector3(0,-180,0);
    [SerializeField] private Ease _cubeEase;

    [SerializeField] private float _startNoiseZ = -.6f;
    [SerializeField] private float _endNoiseZ = .3f;
    [SerializeField] private float _minNoise = .005f;
    [SerializeField] private float _MaxNoise = .05f;
    [SerializeField] private float _minNoiseDuration = 1;
    [SerializeField] private float _MaxNoiseDuration = 2;

    [SerializeField] private float _minBloom = 1, _maxBloom = 3;
    [SerializeField] private PostProcessVolume _volume;
    [SerializeField] private bool _distort;

    [SerializeField] private Light _light;
    [SerializeField] private float _MaxLight = 12;
    private Bloom _bloom;
    void Start() {
        _volume.profile.TryGetSettings(out _bloom);
        _camTransform.rotation = Quaternion.Euler(_startRot);

        DOVirtual.Float(0, _MaxLight, _maxSpeed, (v) =>_light.intensity = v);

        var mySequence = DOTween.Sequence();

        foreach (Transform cube in _faceParent) {
            var startPos = cube.position;
            cube.position = cube.position + Random.insideUnitSphere * _scatterAmount;
            mySequence.Insert(0, cube.DOMove(startPos, Random.Range(_minSpeed, _maxSpeed)).SetEase(_cubeEase).OnComplete(() => {
                var point = Mathf.InverseLerp(_startNoiseZ, _endNoiseZ, cube.position.z);
                var noise = Mathf.Lerp(_minNoise, _MaxNoise, point);
                var duration = Mathf.Lerp(_minNoiseDuration, _MaxNoiseDuration, point);
              if(_distort)  cube.DOMoveY(cube.position.y - Random.Range(-noise, noise), duration).SetLoops(-1, LoopType.Yoyo).SetEase(Ease.InOutQuad);
            }));
        }

        mySequence.Insert(0, _camTransform.DORotate(_endRot, _maxSpeed));


        mySequence.OnComplete(() => {
         //   _particles.SetActive(true);
            DOVirtual.Float(_minBloom, _maxBloom, 3, (f) => _bloom.intensity.value = f).SetLoops(-1,LoopType.Yoyo).SetEase(Ease.InOutQuad);
        });
    }

}


