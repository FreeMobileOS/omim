project(opening_hours_supported_features_tests)

include_directories(${PROJECT_SOURCE_DIR} ${OMIM_ROOT}/3party/opening_hours)

set(
  SRC
  opening_hours_supported_features_tests.cpp
)

add_executable(${PROJECT_NAME} ${SRC})
omim_link_libraries(${PROJECT_NAME} base opening_hours)
