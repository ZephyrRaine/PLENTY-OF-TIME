using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using System;

public class FeedbackIcon : MonoBehaviour
{
    public Image glow;
    public Image sprite;
    public Color activeColor;
    bool a = false;
    // Start is called before the first frame update
    void Start()
    {
        Color c = activeColor;
        c.a = 0f;
        glow.color = c;
        sprite.color = Color.white;
    }

    [ContextMenu("ToggleFeedback")]
    public void ToggleFeedback(bool b)
    {
        Debug.Log($"Toggle feedback {b}");
        //if(a != b)
        //    a = b;
        //else 
        //    return;
        a = b;
        glow.DOFade(a?1f:0f, 1f);
        sprite.DOColor(a?activeColor:Color.white, 1f);
    }
    ParticleSystem _ps;
    ParticleSystem ps
    {
        get
        {
            if (_ps == null)
                _ps = GetComponentInChildren<ParticleSystem>();

            return _ps;
        }
    }

    public void Tick()
    {
        Debug.Log("Tick");
        ps.Clear();
        ps.Simulate(0f);
        ps.Play();
    }
}
