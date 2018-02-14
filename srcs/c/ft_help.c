/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_help.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: cjacquet <cjacquet@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2018/01/24 11:55:45 by cjacquet          #+#    #+#             */
/*   Updated: 2018/01/24 15:18:05 by cjacquet         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h"

void				sdl_init_menus(t_sdl *sdl)
{
    if (!(sdl->help_menu = SDL_CreateRGBSurfaceWithFormat(0, 200, sdl->size.y,
		32, sdl->screen->format->format)))
		errors(ERR_SDL, "SDL_CreateRGBSurface menu_help failed --");
    //Fill surface with gray 0x696969 or rgb 105 105 105
}