---
layout: default
# for pandoc
geometry: "left=3cm,right=3cm,top=2cm,bottom=2cm"
colorlinks: true
linkcolor: "blue"
urlcolor: "blue"
toccolor: "gray"
output: pdf_document
header-includes:
    - \usepackage{xcolor}
    - \usepackage{listings}
    - \lstset{breaklines=true}
    - \lstset{language=[Motorola68k]Assembler}
    - \lstset{basicstyle=\small\ttfamily}
    - \lstset{extendedchars=true}
    - \lstset{tabsize=2}
    - \lstset{columns=fixed}
    - \lstset{showstringspaces=false}
    - \lstset{frame=trbl}
    - \lstset{frameround=tttt}
    - \lstset{framesep=4pt}
    - \lstset{numbers=left}
    - \lstset{numberstyle=\tiny\ttfamily}
    - \lstset{postbreak=\raisebox{0ex}[0ex][0ex]{\ensuremath{\color{red}\hookrightarrow\space}}}
---
# Root Access

This document provides methods for obtaining temporary root access on a remote system.

## 1\. Install GNU Screen (Recommended)

GNU Screen is highly recommended for managing remote sessions, and required for the ["Open a screen session with a running `su`"](#option-3-open-a-screen-session-with-su) method. Install it using:

```bash
sudo apt install screen
```

## 2\. Temporary Root Access Options

### Option 1: Password (Unsafe)

Temporarily change the root password using:

```bash
passwd
```

**Warning:** This method is generally unsafe for remote access.

### Option 2: `sudo` with `NOPASSWD`

This method grants temporary `sudo` privileges without requiring a password.

Create a file named `/etc/sudoers.d/90-temp-user` and add the following content, replacing `andrew` with the actual username:

```
# User rules for andrew
andrew ALL=(ALL) NOPASSWD:ALL
```

Alternatively, you can create this file directly using the command:

```bash
cat << EOF | sudo tee /etc/sudoers.d/90-temp-user
# User rules for $(id -un)
$(id -un) ALL=(ALL) NOPASSWD:ALL
EOF
```

### Option 3: Open a Screen Session with `su`

This method involves starting a `screen` session and elevating privileges within it, allowing for later resumption of the privileged session.

1.  Start a `screen` session:

    ```bash
    screen
    ```

2.  Elevate privileges within the `screen` session:

    ```bash
    sudo su
    ```

3.  (Optional) Detach from the session by pressing `Ctrl+a d`.

After connecting to the client machine, this `screen` session can be resumed to regain root access.
