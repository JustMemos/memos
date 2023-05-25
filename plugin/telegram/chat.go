package telegram

type Chat struct {
	Id        int    `json:"id"`
	Title     string `json:"title"`
	Type      string `json:"type"`
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
}
