const API_URL = "https://teresa-semiradical-odilia.ngrok-free.dev";

// dashboard
async function dashboard(){

    const res = await fetch(`${API_URL}/dashboard`,{
        headers:{
            "ngrok-skip-browser-warning":"true"
        }
    });

    return await res.json();
}

// items
async function getItems(){

    const res = await fetch(`${API_URL}/items`,{
        headers:{
            "ngrok-skip-browser-warning":"true"
        }
    });

    return await res.json();
}

// delete
async function deleteItem(id){

    const res = await fetch(`${API_URL}/delete-item/${id}`,{
        method:"DELETE",
        headers:{
            "ngrok-skip-browser-warning":"true"
        }
    });

    return await res.json();
}