using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using TMPro;
using System;

public class UIFeedback : MonoBehaviour /*IPointerEnterHandler, IPointerExitHandler*/
{
    public Image image;
    public TMP_Text text;
    public Player player;
    bool isActive;
    bool currentSide;

    public Power power;
    void Start()
    {
        //image = GetComponent<Image>();
        //text = GetComponentInChildren<TMP_Text>();

        image.color = Color.clear;
        text.text = "";
    }
    //public void OnPointerClick(PointerEventData eventData)
    //{

    //}

   public void Toggle(Player f)
    {
        Color c = f==player ? Color.green : Color.red;

        c.a = 0.15f;
        image.color = c;
        if(text != null)
               text.text = f==player ? "+" : "-";


    }

    public void Hide()
    {
        image.color = Color.clear;
        if (text != null)
            text.text = "";
    }

    public void Activate(Player f)
    {
        power.Launch(f,player,(f==player?0:1));
    }

    //public void OnPointerEnter(PointerEventData eventData)
    //{

    //    Toggle();  
    //}

    //public void OnPointerExit(PointerEventData eventData)
    //{
    //    Hide();
    //}

}
