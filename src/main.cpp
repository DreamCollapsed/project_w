#include <folly/AtomicHashMap.h>

#include <iostream>
#include <memory>

#include "unique_ptr/unique_ptr.h"

int main() {
  std::string str = "test unique ptr";
  std::string str1 = "suc";

  UniquePtr<std::string> ptr(new std::string("hello"));
  UniquePtr<std::string> ptr1;
  ptr1 = std::move(ptr);
  UniquePtr<std::string> ptr2(new std::string("world"));
  UniquePtr<std::string> ptr3(std::move(ptr2));
  std::cout << "str: " << &str << std::endl;
  std::cout << "ptr: " << ptr.get() << std::endl;
  std::cout << "ptr1: " << ptr1.get() << std::endl;
  std::cout << "ptr2: " << ptr2.get() << std::endl;
  std::cout << "ptr3: " << ptr3.get() << std::endl;
  ptr3.reset();
  std::cout << "reset ptr3: " << ptr3.get() << std::endl;
  ptr1.release();
  std::cout << "release ptr1: " << ptr2.get() << std::endl;

  std::shared_ptr<folly::AtomicHashMap<int, int>> ahm_ptr =
      std::make_shared<folly::AtomicHashMap<int, int>>(10);
  ahm_ptr->insert(10, 20);
  std::cout << ahm_ptr->size() << std::endl;
  return 0;
}
