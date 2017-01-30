using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WebCameraTest : MonoBehaviour {

		public int Width = 1920;
		public int Height = 1080;
		public int FPS = 30;

		void Start () {
			WebCamDevice[] devices = WebCamTexture.devices;
			// display all cameras
			for (var i = 0; i < devices.Length; i++) {
				Debug.Log (devices [i].name);
			}

			WebCamTexture webcamTexture = new WebCamTexture(devices[0].name, Width, Height, FPS);
			GetComponent<Renderer> ().material.mainTexture = webcamTexture;
			webcamTexture.Play();
		}
	}