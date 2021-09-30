using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FaceCube : MonoBehaviour {
    [SerializeField] private Material _blue, _orange;
    [SerializeField] private MeshRenderer _renderer;
    private bool _isBlue;
    void OnMouseDown() {
        _isBlue = !_isBlue;
        _renderer.material = _isBlue ? _orange : _blue;
    }
}
