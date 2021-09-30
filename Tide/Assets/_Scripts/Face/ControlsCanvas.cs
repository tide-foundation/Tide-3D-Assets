using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using UnityEngine.UI;

public class ControlsCanvas : MonoBehaviour {
    [SerializeField] private GameObject _canvas;
    [SerializeField] private FlyCamera _flyer;

    [SerializeField] private Slider _gradientSlider,_bloomSlider,_depthSlider,_chromaticSlider;
    [SerializeField] private SpriteRenderer _gradient;

    [SerializeField] private List<ScatterCube> _scatterCubes;

    [SerializeField] private PostProcessVolume _volume;

    private Bloom _bloom;

    private DepthOfField _depth;

    private ChromaticAberration _chromatic;
    // Start is called before the first frame update
    void Start() {
        _volume.profile.TryGetSettings(out _bloom);
        _volume.profile.TryGetSettings(out _depth);
        _volume.profile.TryGetSettings(out _chromatic);

        _bloomSlider.value = Mathf.InverseLerp(0, 4, _bloom.intensity.value);
        _depthSlider.value = Mathf.InverseLerp(.1f, 32, _depth.aperture.value);
        _chromaticSlider.value = _chromatic.intensity.value;
      
        _canvas.SetActive(true);
        _flyer.enabled = false;

        _gradientSlider.onValueChanged.AddListener((f) => {
            _gradient.color = Color.Lerp(Color.white, Color.black, f);
        });

        _bloomSlider.onValueChanged.AddListener((f) => {
            _bloom.intensity.value = Mathf.Lerp(0, 4, f);
        });

        _depthSlider.onValueChanged.AddListener((f) => {
            _depth.aperture.value = Mathf.Lerp(0.1f, 32, f);
        });

        _chromaticSlider.onValueChanged.AddListener((f) => {
            _chromatic.intensity.value = f;
        });

      
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape)) {
            _canvas.SetActive(!_canvas.activeSelf);
            _flyer.enabled = !_flyer.enabled;
        }
    }

    public void ScatterCubes() {
        foreach (var scatterCube in _scatterCubes) {
            scatterCube.ScatterCubes();
        }
    }
}
