/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   draw.cl                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/07/04 14:38:00 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/11/02 17:51:27 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"

void	ft_putpixel(t_win *win, int y, int x, int color)
{
	int		i;

	i = 0;
	if (x < IMG_W && y < IMG_H && x >= 0 && y >= 0)
	{
		i = win->linelen * y + x * (win->bpp / 8);
		win->data[i] = color & 0xff;
		win->data[++i] = color >> 8 & 0xff;
		win->data[++i] = color >> 16 & 0xff;
	}
}

int		ft_texture(t_rt *rt)
{
	t_vector	hit;

	hit = rt->eye.pos + rt->ray.dir * rt->ray.t;
	if (hit.x > 0 && hit.z > 0)
	{
		if ((fmod(hit.x+ 1000.0, 50.0) > 25.0 && fmod(hit.z + 1000.0, 50.0) > 25.0) || \
			(fmod(hit.x+ 1000.0, 50.0) < 25.0 && fmod(hit.z + 1000.0, 50.0) < 25.0))
			return (0);
		return (255 << 16 | 255 << 8 | 255);
	}
	return (255 << 16 | 255 << 8 | 255);
}

int		ft_get_obj_color(t_rt *rt, double l)
{
	int		color;
	int		red;
	int		blue;
	int		green;
	int		i;

	color = 0;
	i = rt->ray.id;
	if (i < 0)
		return (0);
	if (i >= rt->nb_obj)
		return ((int)(255 * l) << 16 | (int)(255 * l) << 8 | (int)(255 * l));
	rt->ray.bounces = MAX_BOUNCES;
	if (rt->objects[i].reflect > 0)
		color = ft_reflection(rt);
	else if (rt->objects[i].refract > 0)
		color = ft_refraction(rt);
	// else if (i == 0)
	// 	color = ft_texture(rt);
	else
		color = rt->objects[i].color;
	l = ft_limits(l, 0.0, 2.0);
	blue = ft_limits(ft_limits(((color & 0xff) * l), 0.0, 255.0) + \
						ft_limits(255.0 * (l - 1.0), 0.0, 255.0), 0.0, 255.0);
	green = ft_limits(ft_limits(((color >> 8 & 0xff) * l), 0.0, 255.0) + \
						ft_limits(255.0 * (l - 1.0), 0.0, 255.0), 0.0, 255.0);
	red = ft_limits(ft_limits(((color >> 16 & 0xff) * l), 0.0, 255.0) + \
						ft_limits(255.0 * (l - 1.0), 0.0, 255.0), 0.0, 255.0);
	return (red << 16 | green << 8 | blue);
}
