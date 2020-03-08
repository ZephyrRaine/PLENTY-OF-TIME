using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

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
        if(a!=b)
            a = b;
        else 
            return;

        glow.DOFade(a?1f:0f, 1f);
        sprite.DOColor(a?activeColor:Color.white, 1f);
    }
}
