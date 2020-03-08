﻿using System.Collections;
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

    public bool isOccupyByPlayer;
    public bool isOccupyByOpponent;

    public Canvas parentCanvas;
    public bool checkDeadZone = false;

    public GameObject fuck;
    public void  OnPlayerEnter(Player enterPlayer)
    {
        if (enterPlayer.playerId == player.playerId)
        {
            // Owner enter
            isOccupyByPlayer = true;
        }
        else
        {
            // Enemy enter
            isOccupyByOpponent = true;
        }

        if (fuck != null)
            fuck.SetActive(true);
        UpdateState();
    }

    public void OnPlayerExit(Player exitPlayer)
    {
        if (exitPlayer.playerId == player.playerId)
        {
            // Owner out
            isOccupyByPlayer = false;
        }
        else
        {
            // Enemy out
            isOccupyByOpponent = false;
        }
        if(fuck != null)
            fuck.SetActive(false);
        UpdateState();
    }

    public void UpdateState()
    {
        if (isOccupyByPlayer == true)
        {
            Color c = new Color(0f, 1f, 0.2400875f, 0.1333333f);
            //c.a = 0.15f;
            image.color = c;
            if (text != null)
                text.text = "+";
        }
        else if (isOccupyByOpponent == true)
        {
            Color c = new Color(1f, 0f, 0.2127948f, 0.2196078f);
            //c.a = 0.15f;
            image.color = c;
            if (text != null)
                text.text = "-";
        }
        else
        {
            image.color = Color.clear;
            if (text != null)
                text.text = "";
        }
    }

    public Power power;
    void Start()
    {
        //image = GetComponent<Image>();
        //text = GetComponentInChildren<TMP_Text>();

        image.color = Color.clear;

        if (text != null)
            text.text = "";
    }
    //public void OnPointerClick(PointerEventData eventData)
    //{

    //}

        /*
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
    */

    public void Activate(Player f)
    {
        if (f.playerId == player.playerId && isOccupyByPlayer)
        {
            power.Launch(f, player, 0);
        }
        else if (f.playerId != player.playerId && isOccupyByPlayer == false)
        {
            power.Launch(f, player, 1);
        }
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
