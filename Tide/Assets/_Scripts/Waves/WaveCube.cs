using UnityEngine;

public class WaveCube : MonoBehaviour {
    [SerializeField] private Material _normal, _orange;
    [SerializeField] private MeshRenderer _renderer;
    public Vector3Int GridPos { get; private set; }
    private float _offset;
    private bool _shaking;

    public void Init(Vector3Int gridPos, float offset,bool isOrange) {
        _offset = offset;
        GridPos = gridPos;
        _renderer.material = isOrange ? _orange : _normal;
    }

    void Update()
    {
        var sin = Mathf.Sin(Time.time + _offset);
        transform.position = new Vector3(transform.position.x, sin * CubeWaveManager.Instance.WaveMagnitude, transform.position.z);
    }
}
