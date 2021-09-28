using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class ScatterCube : MonoBehaviour
{
    [SerializeField] private GameObject _prefab;

    [SerializeField] private int _count = 2000;

    [SerializeField] private float _radius = 30;

    [SerializeField] private float _scatterAmount = 1;
    // Start is called before the first frame update
    [SerializeField] private float _minScale = 1, _maxScale = 2;
    [SerializeField] private bool _move;
    [SerializeField] private float  _maxMove = 2;
    [SerializeField] private Ease _ease;
    void Start()
    {
        for (int i = 0; i < _count; i++)
        {
            var cube = Instantiate(_prefab, transform.position + Random.insideUnitSphere * _radius, Quaternion.identity, transform);
            var scale = Random.Range(_minScale, _maxScale);
            cube.transform.localScale = new Vector3(scale, scale, scale);
            //var scale = Random.Range(-_scaleModifier, _scaleModifier) + cube.transform.localScale.x;
            //_cubes.Add(cube.transform);
            // cube.transform.localScale = new Vector3(scale, scale, scale);

            if (_move) cube.transform.DOLocalMoveY(cube.transform.localPosition.y + Random.Range(-_maxMove, _maxMove), Random.Range(1f,2f)).SetEase(_ease).SetLoops(-1, LoopType.Yoyo);
        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;

        Gizmos.DrawWireSphere(transform.position, _radius);
    }
}
