using UnityEngine.Events;
using System; 
public class Timer
{
    private float _total = 0f;
    private float _step = 0f;

    private float   _duration = 0f;
    private bool    _isLoop = false;
    private float   _tick = 0f;
    private bool    _isTick = false;

    public Action ticked;
    public Action stoped;
    public Action started;

    public bool running = false;

    public float progress { get { return _total / _duration; } }

    public string currentTime
    {
        get
        {
            int numberOfSeconds = (int)_total;
            int numberOfMinutes = (int)(_total / 60);

            numberOfSeconds -= (numberOfMinutes * 60);

            return string.Format("{0}:{1}", numberOfMinutes.ToString("00"), numberOfSeconds.ToString("00"));
        }
    }

    public Timer (float duration, float tick = 0f, bool loop = false)
    {
        _duration = duration;
        _isLoop = loop;


        if (tick > 0f)
        {
            _tick = tick;
            _isTick = true;
        }
    }

    public void Start ()
    {
        running = true;
        started?.Invoke();
    }

    public void Stop ()
    {
        running = false;
        _total = 0f;
        _step = 0f;
    }

    public void Update(float deltaTime)
    {
        if(!running)
            return;

        _total += deltaTime;
        _step += deltaTime;

        if (_isTick == true && _step >= _tick)
        {
            ticked?.Invoke();
            _step -= _tick;
        }

        if (_total >= _duration)
        {
            _total -= _duration;

            if (_isLoop == false)
            {
                _total = 0f;
                running = false;
            }

            stoped?.Invoke();
        }
    }
}
