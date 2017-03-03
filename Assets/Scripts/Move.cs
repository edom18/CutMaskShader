using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Move : MonoBehaviour
{
    [SerializeField]
    private float _frecency = 2f;

    [SerializeField]
    private float _speed = 2f;

    private Vector3 _origin;

	void Start()
    {
        _origin = transform.position;
	}
	
	void Update()
    {
        float z = Mathf.Sin(Time.time * _speed) * _frecency;
        transform.position = _origin + new Vector3(0, 0, z);
	}
}
