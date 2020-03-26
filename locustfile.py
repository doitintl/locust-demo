from locust import HttpLocust, TaskSet, task

# def login(l):
#     l.client.post("/login", {"username":"ellen_key", "password":"education"})

# def logout(l):
#     l.client.post("/logout", {"username":"ellen_key", "password":"education"})


class UserBehavior(TaskSet):
    @task(7)
    def index(l):
        h={'x-custom-header':'locust-header'}
        response = l.client.get("/", headers=h)
        print("Response status code:", response.status_code)

    @task(1)
    def profile(l):
        l.client.get("/profile")
    # tasks = {index: 2, profile: 1}

    # def on_start(self):
    #     login(self)

    # def on_stop(self):
    #     logout(self)

class WebsiteUser(HttpLocust):
    host = "http://emailerer.com"
    task_set = UserBehavior
    min_wait = 1000
    max_wait = 3000