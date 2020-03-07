public class AtmospherePower : Power
{
    public override void Launch(Player source, Player target, int option)
    {
        // check if cloud < 5

        base.Launch(source, target, option);

        if (option == 0)
            target.playerScore.cloudCount++;
        else
            target.playerScore.cloudCount--;
    }
}
