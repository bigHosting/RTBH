
use Fcntl ':flock';          # import LOCK_* constants
INIT {
        open  *{0} or die "What!? $0:$!";
        flock *{0}, LOCK_EX|LOCK_NB or die "[*] $0: is already running!n";
}

1;
