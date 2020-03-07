using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode()]
public class OrientProp : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
        transform.LookAt(Vector3.zero);
        transform.rotation=transform.rotation*Quaternion.Euler(-90, 0, 0);
    }
}
