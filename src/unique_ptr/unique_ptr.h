#pragma once

template <typename T>
class UniquePtr {
 public:
  UniquePtr(T* ptr = nullptr) { mptr = ptr; };
  ~UniquePtr() {
    if (mptr) {
      delete mptr;
    };
  };

  UniquePtr(const UniquePtr&) = delete;
  UniquePtr& operator=(const UniquePtr&) = delete;

  UniquePtr(UniquePtr&& other) noexcept {
    this->mptr = other.mptr;
    other.mptr = nullptr;
  }

  UniquePtr& operator=(UniquePtr&& other) {
    this->mptr = other.mptr;
    other.mptr = nullptr;
    return *this;
  }

  void reset(T* ptr = nullptr) {
    if (mptr) {
      delete this->mptr;
    }
    this->mptr = ptr;
  };

  void release() {
    if (mptr) {
      delete this->mptr;
      this->mptr = nullptr;
    }
  };

  T& operator*() const noexcept { return *(this->mptr); };
  T* operator->() const noexcept { return this->mptr; };
  T* get() const noexcept { return this->mptr; };

 private:
  T* mptr = nullptr;
};
