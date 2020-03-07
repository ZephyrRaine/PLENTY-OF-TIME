public class LightPower : Power
{
    public override void Launch(Player source, Player target, int option)
    {
        if (option == 0)
        {
            target.playerScore.light = false;
        }
        else
        {
            target.playerScore.light = true;
        }
    }
}