from django.urls import path
from .views import UserProfileListCreate, UserProfileDetail

urlpatterns = [
    path('user-profiles/', UserProfileListCreate.as_view(), name='userprofile-list-create'),
    path('user-profiles/<int:pk>/', UserProfileDetail.as_view(), name='userprofile-detail'),  # For detail operations including delete
]