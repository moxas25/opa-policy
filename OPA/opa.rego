package barmanagement
import future.keywords

# Default deny access
default allow := false

# Extract roles from JWT
get_roles_from_jwt := roles {
    auth_header := input.request.headers.Authorization
    token := substring(auth_header, count("Bearer "), -1)
    [_, payload, _] := io.jwt.decode(token)
    roles := payload.role
}

# Extract age from JWT
get_age_from_jwt := age {
    auth_header := input.request.headers.Authorization
    token := substring(auth_header, count("Bearer "), -1)
    [_, payload, _] := io.jwt.decode(token)
    age := to_number(payload.age)
}

# Check if the user is a customer
is_customer {
    roles := get_roles_from_jwt
    "customer" == roles[_]

}

is_bartender {
    roles := get_roles_from_jwt
    "bartender" == roles[_]
}

# Allow ordering beer if age is 16 or older
allow if {
    input.request.method == "POST"
    input.request.path == "/api/bar"
    input.request.body.DrinkName == "Beer"
    age := get_age_from_jwt
    age >= 16
}

allow if {

    input.request.method == "POST"
    input.request.path == "/api/managebar"
    is_bartender
    input.request.body.DrinkName == "Whiskey"   
}

# Always allow ordering Fristi
allow if {
    input.request.method == "POST"
    input.request.path == "/api/bar"
    input.request.body.DrinkName == "Fristi"
}

# Deny ordering whiskey if the user is a customer
deny if {
    input.request.method == "POST"
    input.request.path == "/api/managebar"
    input.request.body.DrinkName == "Whiskey"
    is_customer
}
