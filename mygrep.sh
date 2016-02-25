#!/bin/bash

regexp=$1
file=$2

awk '$0~/'$regexp'/' $file

