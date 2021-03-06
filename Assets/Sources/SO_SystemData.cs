using UnityEngine;

[CreateAssetMenu(fileName = "SystemData", menuName = "ScriptableObjects/SystemData", order = 1)]
public class SO_SystemData : ScriptableObject
{
    [Tooltip("Game duration (seconds)")]
    [Range(0f,420f)]

    public float gameDuration;

    [Tooltip("duration of light shut down (seconds)")]
    [Range(0f,10f)]
    public float lightOffTime;

    [Tooltip("number of max clouds")]
    [Range(0,10)]
    public int atmosphereMaximumClouds;

    [Range(0,10)]
    [Tooltip("number of max plants")]
    public int plantsMaximumPlants;

    
    [Range(0,10)]
    [Tooltip("by how much water increases (if sun on)")]
    public int waterIncreaseValue;
    [Range(0f,10f)]
    [Tooltip("how often water increases")]
    public float waterIncreaseTime;


    [Range(0, 10)]
    [Tooltip("by how much water decreases (if moon on))")]
    public int waterDecreaseValue;
    [Range(0f,10f)]
    [Tooltip("how often water decreases")]
    public float waterDecreaseTime;

    [Range(0f, 200f)]
    [Tooltip("how max the watter level can go")]
    public int waterMaximumLevels;

    [Range(0, 10)]
    [Tooltip("how many plants you need to produce animals")]
    public int animalsRequiredPlants;


    [Range(0, 10)]
    [Tooltip("how many animals every increase")]
    public int animalsIncreaseValue;

    [Range(0f,10f)]
    [Tooltip("how often animals increase")]
    public float animalsIncreaseTime;
    [Range(0, 50)]
    [Tooltip("how many score points are added for each animal")]
    public int animalsScoreIncrease;


    [Range(0, 10)]
    [Tooltip("how many clouds you need to produce humans")]
    public int humansRequiredClouds;

    
    [Range(0, 50)]
    [Tooltip("how many water you need to produce humans")]
    public int humansRequiredWater;

    [Range(0, 10)]
    [Tooltip("how many animals you need to produce humans")]
    public int humansRequiredAnimals;

    [Range(0, 10)]
    [Tooltip("how many humans every increase")]
    public int humansIncreaseValue;
    [Range(0f,10f)]
    [Tooltip("how often humans increase")]
    public float humansIncreaseTime;

    [Range(0, 50)]
    [Tooltip("how many score points are added for each human")]
    public int humansScoreIncrease;
    
}