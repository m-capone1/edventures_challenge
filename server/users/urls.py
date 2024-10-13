from django.urls import path
from .views import UserProfileListCreate

urlpatterns = [
    path('user-profiles/', UserProfileListCreate.as_view(), name='userprofile-list-create'),
]