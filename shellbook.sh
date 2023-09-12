#!/bin/bash

# Initialize user database (a text file)
user_database="users.txt"
touch "$user_database"

# Initialize posts database (a text file)
post_database="posts.txt"
touch "$post_database"

# Initialize messages database (a text file)
message_database="messages.txt"
touch "$message_database"


# Function to register a new user
register_user() {
    echo "Enter your username:"
    read username

    # Check if the username already exists
    if grep -q "^$username$" "$user_database"; then
        echo "Username already exists. Please choose a different one."
        return
    fi

    echo "Enter your password:"
    read -s password
    echo "$username:$password" >> "$user_database"
    echo "Registration successful. You can now log in."
}

# Function to log in
login() {
    echo "Enter your username:"
    read username

    # Check if the username exists
    if grep -q "^$username:" "$user_database"; then
        echo "Enter your password:"
        read -s password

        # Verify the password
        if grep -q "^$username:$password$" "$user_database"; then
            echo "Login successful."
            menu
        else
            echo "Incorrect password."
        fi
    else
        echo "Username not found."
    fi
}

# Function to post an update
post_update() {
    echo "Enter your update:"
    read update
    echo "$(date '+%Y-%m-%d %H:%M:%S') $username: $update" >> "$post_database"
    echo "Update posted."
}

# Function to view the timeline
view_timeline() {
    echo "Timeline:"
    cat "$post_database"
}

# Function to send a message
send_message() {
    echo "Enter the recipient's username:"
    read recipient

    # Check if the recipient exists
    if ! grep -q "^$recipient:" "$user_database"; then
        echo "Recipient not found."
        return
    fi

    echo "Enter your message:"
    read message
    echo "$(date '+%Y-%m-%d %H:%M:%S') $username -> $recipient: $message" >> "$message_database"
    echo "Message sent."
}

# Function to view messages
view_messages() {
    echo "Your messages:"
    grep "$username ->" "$message_database" | sed "s/$username -> //"
}

# Main menu
menu() {
    while true; do
        echo "ShellBook - Menu"
        echo "1. Post an update"
        echo "2. View timeline"
        echo "3. Send a message"
        echo "4. View messages"
        echo "5. Logout"
        echo "6. Exit"
        read choice

        case $choice in
            1) post_update ;;
            2) view_timeline ;;
            3) send_message ;;
            4) view_messages ;;
            5) echo "Logged out."; return ;;
            6) exit ;;
            *) echo "Invalid choice. Please try again." ;;
        esac
    done
}

# Main program loop
while true; do
    echo "ShellBook"
    echo "1. Register"
    echo "2. Login"
    echo "3. Exit"
    read option

    case $option in
        1) register_user ;;
        2) login ;;
        3) exit ;;
        *) echo "Invalid option. Please try again." ;;
    esac
done
