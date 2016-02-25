#!/bin/bash

regexp=$1
file=$2

awk -v reg=$regexp '$0~/reg/' $1

