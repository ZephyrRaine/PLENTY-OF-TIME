﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectFeedback : MonoBehaviour
{
    List<GameObject> allProps;
    List<GameObject> availableProps;
    List<GameObject> busyProps;

    GameObject particleSystemObject;

    
    private void Start()
    {
        availableProps = new List<GameObject>();
        busyProps = new List<GameObject>();

        for(int i = 0; i < transform.childCount; i++)
        {
            GameObject go = transform.GetChild(i).gameObject;
            go.SetActive(false);
            availableProps.Add(go);
        }
    }

    public void PopObject()
    {
        if(availableProps.Count > 0)
        {
            GameObject go = availableProps[Random.Range(0, availableProps.Count)];
            availableProps.Remove(go);
            busyProps.Add(go);
            go.SetActive(true);
            Vector3 center = Vector3.zero;
            foreach(Transform t in go.transform)
            {
                center += t.position;
            }
            center /= go.transform.childCount;
            GameObject gao = Instantiate(particleSystemObject, center, Quaternion.identity);
            gao.transform.LookAt(Vector3.zero);
        }
    }

    public void RemoveObject()
    {
        if(busyProps.Count > 0)
        {
            GameObject go = busyProps[Random.Range(0, busyProps.Count)];
            busyProps.Remove(go);
            availableProps.Add(go);
            go.SetActive(false);
        }
    }

    public void GiveParticleSystem(GameObject prefab)
    {
        particleSystemObject = prefab;
    }

}
