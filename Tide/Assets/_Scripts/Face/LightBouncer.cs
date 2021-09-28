using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class LightBouncer : MonoBehaviour {
    [SerializeField] private Light _light;

    [SerializeField] private float  _goal;

    [SerializeField] private float _speed;

    [SerializeField] private Ease _ease;
    // Start is called before the first frame update
    void Start() {

        _light.DOIntensity(_goal, _speed).SetEase(_ease).SetLoops(-1, LoopType.Yoyo);
    }


}
