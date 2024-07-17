document.addEventListener("DOMContentLoaded", () => {
  const searchInput = document.getElementById("search-suggestion");
  const suggestionsBox = document.getElementById("suggestions-box");
  const checkWeatherBtn = document.getElementById("check-weather-btn");
  const searchIcon = document.getElementById("search-icon");

  let timeout = null;

  searchInput.addEventListener("input", () => {
    const query = searchInput.value;
    if (query.length > 0) {
      searchIcon.classList.add("hidden");
    } else {
      searchIcon.classList.remove("hidden");
    }

    if (query.length < 3) {
      suggestionsBox.classList.add("hidden");
      searchInput.style.borderRadius = "25px";

      return;
    }

    if (timeout) clearTimeout(timeout);

    suggestionsBox.innerHTML = '<div class="loading ">Loading...</div>';
    suggestionsBox.classList.remove("hidden");
    searchInput.style.borderRadius = "25px 25px 0 0";
    searchInput.style.border = "2px solid black";
    checkWeatherBtn.classList.add("hidden");

    timeout = setTimeout(() => {
      fetchSuggestions(query);
    }, 300);
  });

  const fetchSuggestions = (query) => {
    fetch(`/suggest?q=${query}`)
      .then((response) => response.json())
      .then((data) => {
        if (data && data.length > 0) {
          suggestionsBox.innerHTML = data
            .map(
              (item) =>
                `<div class="suggestion-item " data-location="${item?.name}, ${item?.country}">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path fill-rule="evenodd" clip-rule="evenodd" d="M6.05997 4.86C7.63536 3.28461 9.77204 2.39957 12 2.39957C14.2279 2.39957 16.3646 3.28461 17.94 4.86C19.5154 6.43539 20.4004 8.57207 20.4004 10.8C20.4004 13.0279 19.5154 15.1646 17.94 16.74L12 22.68L6.05997 16.74C5.27987 15.96 4.66105 15.0339 4.23886 14.0147C3.81667 12.9955 3.59937 11.9032 3.59937 10.8C3.59937 9.69682 3.81667 8.60445 4.23886 7.58526C4.66105 6.56607 5.27987 5.64002 6.05997 4.86ZM12 13.2C12.6365 13.2 13.2469 12.9471 13.697 12.4971C14.1471 12.047 14.4 11.4365 14.4 10.8C14.4 10.1635 14.1471 9.55303 13.697 9.10294C13.2469 8.65286 12.6365 8.4 12 8.4C11.3635 8.4 10.753 8.65286 10.3029 9.10294C9.85283 9.55303 9.59997 10.1635 9.59997 10.8C9.59997 11.4365 9.85283 12.047 10.3029 12.4971C10.753 12.9471 11.3635 13.2 12 13.2Z" fill="#5BAEFB"/>
                </svg>
                ${item?.name}, ${item?.country}
            </div>`
            )
            .join("");
          attachClickHandlers();
        } else {
          suggestionsBox.innerHTML =
            '<div class="loading ">No results found</div>';
        }
      })
      .catch((error) => {
        console.error("Error fetching suggestions:", error);
        suggestionsBox.innerHTML =
          '<div class="loading">Error fetching suggestions</div>';
      });
  };

  const attachClickHandlers = () => {
    const items = document.querySelectorAll(".suggestion-item");
    items.forEach((item) => {
      item.addEventListener("click", () => {
        searchInput.value = item.getAttribute("data-location");
        suggestionsBox.classList.add("hidden");
        searchInput.style.borderRadius = "25px";
        checkWeatherBtn.classList.remove("hidden");
      });
    });
  };

  document.addEventListener("click", (event) => {
    if (
      !suggestionsBox.contains(event.target) &&
      event.target !== searchInput
    ) {
      suggestionsBox.classList.add("hidden");
      searchInput.style.borderRadius = "25px";
    }
  });
});
